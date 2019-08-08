import requests
import json

# Datavask URL => GET
DV_URL = "https://dawa.aws.dk/datavask/adresser"

# Geometri URL => ENDPOINT
GEO_URL = "https://dawa.aws.dk/adgangsadresser/"

class Adresse:
    # Memory optimization.
    # Disallows adding new attributes after instantiation.
    __slots__ = ["raw", "category", "adgAdrID", "vejnavn", "husnr", "etage", "dor", "postnr", "by", "coordinates"]
    def __init__(self, raw=None, category=None, adgAdrID=None, vejnavn=None, husnr=None, etage=None, dor=None, postnr=None, by=None, coordinates=[None]*2):
        self.raw         = raw     
        self.category    = category
        self.adgAdrID    = adgAdrID
        self.vejnavn     = vejnavn 
        self.husnr       = husnr   
        self.etage       = etage   
        self.dor         = dor     
        self.postnr      = postnr  
        self.by          = by
        self.coordinates = coordinates

    def __str__(self):
        s = "-"*45 + "\n"
        s += f"Raw: {self.raw}\n"      
        s += f"Kategori: {self.category}\n" 
        s += f"AdgangsadresseID: {self.adgAdrID}\n"
        s += f"Vejnavn: {self.vejnavn}\n" 
        s += f"Husnr: {self.husnr}\n" 
        s += f"Etage: {self.etage}\n" 
        s += f"Dør: {self.dor}\n"   
        s += f"Postnr: {self.postnr}\n"
        s += f"By: {self.by}\n"
        s += f"Koordinater: {self.coordinates}\n"
        s += "-"*45
        return s
    def geojson_feature(self):
        return json.dumps(self.geojson_feature_dict())

    def geojson_feature_dict(self):
        return {
                "type": "Feature",
                "properties": {
                    "raw" : self.raw,
                    "category" : self.category,
                    "adgAdrID" : self.adgAdrID,
                    "vejnavn" : self.vejnavn,
                    "husnr" : self.husnr,
                    "etage" : self.etage,
                    "dor" : self.dor,
                    "postnr" : self.postnr,
                    "by" : self.by
                },
                "geometry": {
                    "type": "Point",
                    "coordinates": self.coordinates
                }
        }
      
class Parser:
    def __init__(self):
        self.ab = []
        self.c = []
        self.counts = {'A': 0, 'B': 0, 'C': 0}

    def parse(self, adrs):
        assert type(adrs) == list
        n = len(adrs)
        assert n > 0

        for i, adr in enumerate(adrs):
            if i % 100 == 0:
                print(f"{i/n:.2%}")
            params = {"betegnelse": adr}
            resp = requests.get(DV_URL, params)
            assert resp.status_code == 200
            data = resp.json()
            if data["kategori"] == "C":
                self.c.append(Adresse(raw=adr))
                continue
            
            self.counts[data["kategori"]] += 1

            res = data["resultater"]
            m = max(res, key=lambda el: int(el["vaskeresultat"]["afstand"]))
            akt = m["aktueladresse"]
            self.ab.append(Adresse(
                raw=adr,
                category=data["kategori"],
                adgAdrID=akt["adgangsadresseid"],
                vejnavn=akt["vejnavn"],
                husnr=akt["husnr"],
                etage=akt["etage"],
                dor=akt["dør"],
                postnr=akt["postnr"],
                by=akt["postnrnavn"]
            ))
        
        if len(self.c) > 0:
            self.handle_c()
        
        for val in self.ab:
            resp = requests.get(F"{GEO_URL}{val.adgAdrID}")
            assert resp.status_code == 200
            val.coordinates = resp.json()["adgangspunkt"]["koordinater"]

        print(f"A: {len(self.counts['A'])}/{len(adrs)}\nB: {len(self.counts['B'])}/{len(adrs)}\nC: {len(self.counts['C'])}/{len(adrs)}\n")
    
    def handle_c(self):
        pass

    def ab_as_geojson(self):
        assert len(self.ab) != 0
        features = list(map(lambda x: x.geojson_feature_dict(), self.ab))
        coll = {
            "type": "FeatureCollection",
            "features": features
        }
        return json.dumps(coll)


if __name__ == '__main__':
    # TEST!
    p = Parser()
    p.parse(["Fiskergade 5-6", "Borger gade 4, STTV, 6000 Kolding"])
    p.ab_as_geojson()