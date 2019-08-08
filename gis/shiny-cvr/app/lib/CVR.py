from elasticsearch import Elasticsearch
from elasticsearch_dsl import Search, Q
from datetime import datetime
import os
import json
import csv

USER = os.environ['cvr_user']
PASSWORD = os.environ['cvr_pwd']
HOST = 'distribution.virk.dk/cvr-permanent/'

_es = Elasticsearch(
    [HOST],
    http_auth=(USER, PASSWORD),
    scheme="http",
    port=80,
)

road_arr = [
            "mariendalsvej",
            "smallegade"
            ]

Q_arr = []

query_dict = {
    "_source": [
        "Vrvirksomhed.navne",
        "Vrvirksomhed.livsforloeb",
        "Vrvirksomhed.beliggenhedsadresse",
        "Vrvirksomhed.hovedbranche",
        "Vrvirksomhed.kvartalsbeskaeftigelse",
        "Vrvirksomhed.penheder",
        "Vrvirksomhed.cvrNummer"
    ],
    "size" : 1000,
    "query": {
        "nested" : {
            "path" : "Vrvirksomhed.beliggenhedsadresse",
            "score_mode" : "avg",
            "query" : {
                "constant_score" : {
                    "filter" : {
                        "bool" : {
                            "must" : [
                                { "match" : 
                                    {"Vrvirksomhed.beliggenhedsadresse.kommune.kommuneKode" : 147} 
                                },
                                {
                                    "bool" : {
                                        "must_not" : [
                                            { "range" : {
                                                "Vrvirksomhed.beliggenhedsadresse.periode.gyldigFra" : {
                                                    "gt" : "2018||/y",
                                                    "format" : "yyyy"
                                                    }
                                                }
                                            },
                                            { "range" : {
                                                "Vrvirksomhed.beliggenhedsadresse.periode.gyldigTil" : {
                                                    "lt" : "2018||/y",
                                                    "format" : "yyyy"
                                                    }
                                                }
                                            },
                                            { "range" : {
                                                "Vrvirksomhed.hovedbranche.periode.gyldigFra" : {
                                                    "gt" : "2018||/y",
                                                    "format" : "yyyy"
                                                    }
                                                }
                                            },
                                            { "range" : {
                                                "Vrvirksomhed.hovedbranche.periode.gyldigTil" : {
                                                    "lt" : "2018||/y",
                                                    "format" : "yyyy"
                                                    }
                                                }
                                            }
                                        ]
                                    }
                                },
                                {
                                    "bool" : {
                                        "should" : Q_arr
                                    }
                                }
                            ]
                        }
                    }
                }
            }
        }
    }
}

class Virksomhed:
    __slots__ = ["cvr", "navn", "vej", "husnr", "branche", "branchenavn", "levetid", "antal_medarb"]

    def __init__(self, cvr, navn, vej, husnr, branche, branchenavn, levetid, antal_medarb):
        self.cvr = cvr
        self.navn = navn
        self.vej = vej
        self.husnr = husnr
        self.branche = branche
        self.branchenavn = branchenavn
        self.levetid = levetid
        self.antal_medarb = antal_medarb     

    def __str__(self):
        s = str(self.cvr) + " "*3
        s += self.navn + " "*(75 - len(self.navn))
        s += self.branche + " "*(9-len(self.branche))
        s += str(self.levetid) + " "*(8-len(str(self.levetid)))
        s += self.antal_medarb

        return s

def DB07(el):
    num = int(el)
    # TODO: Handle this somehow
    if num in [7, 34, 40, 44, 48, 89, 54, 57, 67, 76, 83, 89, 98]:
        return "NA", "Koden er forældet"
        # raise ValueError(f"Brancher i {el}.XX.X er ikke defineret i DB07")

    if 1 <= num <= 3:
        return  "A", "Landbrug, skovbrug og fiskeri"
    elif 6 <= num <= 9:
        return  "B", "Industri, råstoffer, forsyning"
    elif 10 <= num <= 33:
        return "C", "Industri"
    elif num == 35:
        return "D", "Energiforsyning"
    elif 36 <= num <= 39:
        return "E", "Vandforsyning og renovation"
    elif 41 <= num <= 43:
        return "F", "Bygge og anlæg"
    elif 45 <= num <= 47:
        return "G", "Handel"
    elif 49 <= num <= 53:
        return "H", "Transport"
    elif 55 <= num <= 56:
        return "I", "Hoteller og restauranter"
    elif 58 <= num <= 63:
        return "J", "Information of kommunikation"
    elif 64 <= num <= 66:
        return "K", "Finansiering of forsikring"
    elif num == 68:
        return "L", "Ejendomshandel og udlejning"
    elif 69 <= num <= 75:
        return "M", "Videnservice"
    elif 77 <= num <= 82:
        return "N", "Rejsebureauer. rengøring mv."
    elif num == 84:
        return "O", "Offentlig adm., forsvar og politi"
    elif num == 85:
        return "P", "Undervisning"
    elif 86 <= num <= 88:
        return "Q", "Sundhed og socialvæsen"
    elif 90 <= num <= 93:
        return "R", "Kultur og fritid"
    elif 94 <= num <= 98:
        return "S", "Andre serviceydelser mv."
    elif num == 99:
        return "X", "Uoplyst aktivitet"
    else:
        return "NA", "Koden er ikke kendt"

def map_antal_ansatte(el):
    # Yes not great I know.
    if el == "ANTAL_0_0": # ?
        return  "0"
    elif el == "ANTAL_1_1" or el == None:
        return  "1"
    elif el == "ANTAL_2_4":
        return "2-4"
    elif el == "ANTAL_5_9":
        return "5-9"
    elif el == "ANTAL_10_19":
        return "10-19"
    elif el == "ANTAL_20_49":
        return "20-49"
    elif el == "ANTAL_50_99":
        return "50-99"
    elif el == "ANTAL_100_199":
        return "100-199"
    elif el == "ANTAL_200_499":
        return "200-499"
    elif el == "ANTAL_500_999":
        return "500-999"
    elif el == "ANTAL_1000_999999":
        return "1000-"
    else:
        raise ValueError(el + " er ikke implementeret i map_antal_ansatte")

def get(Q, branche_filter = None):

    Q_arr = []
    Q_adr_lu = []
    for k, vl in Q.items():
        for v in vl:
            Q_arr.append({ "bool" : {
                "must" : [
                    { "match_phrase" : { "Vrvirksomhed.beliggenhedsadresse.vejnavn" : k } },
                    { "term" : { "Vrvirksomhed.beliggenhedsadresse.husnummerFra" : v } }
                ]
            }})
            Q_adr_lu.append((k, v))
    query_dict["query"]["nested"]["query"]["constant_score"]["filter"]["bool"]["must"][2]["bool"]["should"] = Q_arr
    


    res = {}
    date_format = "%Y-%m-%d"
    for y in range(1999, datetime.now().year + 1):
        year_filter = str(y) + "||/y"
        query_dict["query"]["nested"]["query"]["constant_score"]["filter"]["bool"]["must"][1]["bool"]["must_not"][0]["range"]["Vrvirksomhed.beliggenhedsadresse.periode.gyldigFra"]["gt"] = year_filter
        query_dict["query"]["nested"]["query"]["constant_score"]["filter"]["bool"]["must"][1]["bool"]["must_not"][1]["range"]["Vrvirksomhed.beliggenhedsadresse.periode.gyldigTil"]["lt"] = year_filter
        query_dict["query"]["nested"]["query"]["constant_score"]["filter"]["bool"]["must"][1]["bool"]["must_not"][2]["range"]["Vrvirksomhed.hovedbranche.periode.gyldigFra"]["gt"] = year_filter
        query_dict["query"]["nested"]["query"]["constant_score"]["filter"]["bool"]["must"][1]["bool"]["must_not"][3]["range"]["Vrvirksomhed.hovedbranche.periode.gyldigTil"]["lt"] = year_filter
        
        resp = _es.search(
            index='virksomhed',
            body=query_dict 
        )

        # startyear = datetime.strptime(f"{y}-01-01", date_format)
        endyear = datetime.strptime(str(y) + "-12-31", date_format)
        
        virksomheder = []

        for V in resp["hits"]["hits"]:
            dat = V["_source"]["Vrvirksomhed"]
            # print("---\n")
            # print(dat["hovedbranche"])

            cvr = dat["cvrNummer"]
            navn = ' '.join(dat["navne"][-1]["navn"].split())
            # for el in dat["hovedbranche"]:
            #     if el["periode"]["gyldigTil"] is None:
            #         el["periode"]["gyldigTil"] = datetime.now()
            #     else:
            #         el["periode"]["gyldigTil"] = datetime.strptime(el["periode"]["gyldigTil"], date_format)
            
            branch = list(map(lambda x: {
                "branchekode": x["branchekode"],
                "gyldigTil": datetime.now() if x["periode"]["gyldigTil"] is None else datetime.strptime(x["periode"]["gyldigTil"], date_format)
            }, dat["hovedbranche"] ))
            
            filt = max(branch, key=lambda x: x["gyldigTil"])["branchekode"]
            if branche_filter is not None:
                if filt in branche_filter: continue
            b_kode, b_navn = DB07(filt[:2])
            
            adrs = [[x["vejnavn"], x["husnummerFra"], datetime.strptime(x["periode"]["gyldigFra"], date_format), (datetime.now() if x["periode"]["gyldigTil"] is None else datetime.strptime(x["periode"]["gyldigTil"], date_format))] for x in dat["beliggenhedsadresse"] if 
                (str(x["vejnavn"]).lower(), x["husnummerFra"]) in Q_adr_lu]
                
            if len(adrs) > 1:
                z = list(zip(*adrs))
                # print(z[1])
                # print(z[2])
                _startdato = min(z[2])
                starts = list(z[2])
                ends = list(z[3])
                starts.sort()
                ends.sort()

                for i, s in enumerate(starts[1:]):
                    if (s - ends[i-1]).days > 30 and s < endyear:
                        _startdato = s
                
                _slutdato = max(z[3])
            elif len(adrs) == 1:
                _startdato = adrs[0][2]
                _slutdato = adrs[0][3]
            else:
                print(adrs)
                raise ValueError("Something is wrong with filter")

            vej = adrs[0][0]
            nr = adrs[0][1]

            _slutdato = min([endyear, _slutdato])
            levetid = (_slutdato - _startdato).days
            # print(f"{_startdato} ---> {_slutdato}")

            besk = dat["kvartalsbeskaeftigelse"]
            t = list(filter(lambda x: x["aar"] == y, besk))
            AA = "1" if len(t) == 0 else map_antal_ansatte(max(t, key=lambda x: x['kvartal'])["intervalKodeAntalAnsatte"])

            virk = Virksomhed(
                cvr,
                navn,
                vej,
                nr,
                b_kode,
                b_navn,
                levetid,
                AA
            )
            virksomheder.append(virk)
        res[str(y)] = virksomheder
    return res

def to_csv(filename, data, year_range=range(1999, datetime.now().year + 1)):
    """
    Create CSV from data returned by the get() function
    """
    with open(filename, 'w', newline='') as csvfile:
        fieldnames = ['aar', 'cvr', 'navn', 'vej', 'husnr', 'branche', 'branchenavn', 'levetid', 'antal_medarb']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames, quotechar='"', quoting=csv.QUOTE_ALL)

        writer.writeheader()

        for y in year_range:
            for virk in data["{}".format(y)]:
                writer.writerow({
                    'aar' : y,
                    'cvr' : virk.cvr,
                    'navn' : virk.navn,
                    'vej' : virk.vej,
                    'husnr' : virk.husnr,
                    'branche' : virk.branche,
                    'branchenavn' : virk.branchenavn,
                    'levetid' : virk.levetid,
                    'antal_medarb' : virk.antal_medarb
                })

if __name__ == '__main__':
    res = get(
        {
            "dronning olgas vej" : list(set([1, 2, 2, 3, 4, 5, 6, 7, 9, 10, 11, 14, 15, 15, 17, 19, 20, 20, 21, 22, 23, 24, 25, 26, 26, 26, 27, 28, 29, 30, 31, 33, 35, 37, 39, 41, 43, 43, 45, 47, 37, 39, 18, 18, 18, 18, 28, 18, 18, 18])),
            "prins constantins vej" : list(set([1, 2, 3, 4, 5, 6, 6, 7, 8, 9, 10, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 29, 30, 31, 32, 33, 34, 35, 36, 37, 37, 38, 40, 41, 41, 42, 43, 44, 45, 46, 47, 47, 48, 49, 52, 20, 12, 13, 39, 39, 5])),
            "kong georgs vej" : list(set([3, 7, 8, 5]))
        },
        branche_filter=['683220', '682010', '682020', '682030', '682040']
    )
    
    # h = "CVR" + " "*8 + "Navn" + " "*(71) + "Branche" + " "*2 + "L" + " "*7 + "M"
    # for y in range(1999, 2019):
    #     print(f"\n---[{y}]---\n")
    #     print(h)
    #     for virk in res[f"{y}"]:
    #         print(virk)
    #         print(virk.vej, " ", virk.husnr)
