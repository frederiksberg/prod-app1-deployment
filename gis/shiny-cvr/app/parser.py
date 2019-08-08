import os, sys, pickle, datetime
sys.path.append(os.path.join(os.path.dirname("__file__")))
import lib.CVR

now = datetime.datetime.now().isocalendar()
cache_file = "{}_{}.cache".format(now[0], now[1])

path = os.path.join("./cache", cache_file)
fs = os.path.isfile(path)

if not fs:
    res = lib.CVR.get(
        {
            "dronning olgas vej" : list(set([1, 2, 2, 3, 4, 5, 6, 7, 9, 10, 11, 14, 15, 15, 17, 19, 20, 20, 21, 22, 23, 24, 25, 26, 26, 26, 27, 28, 29, 30, 31, 33, 35, 37, 39, 41, 43, 43, 45, 47, 37, 39, 18, 18, 18, 18, 28, 18, 18, 18])),
            "prins constantins vej" : list(set([1, 2, 3, 4, 5, 6, 6, 7, 8, 9, 10, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 29, 30, 31, 32, 33, 34, 35, 36, 37, 37, 38, 40, 41, 41, 42, 43, 44, 45, 46, 47, 47, 48, 49, 52, 20, 12, 13, 39, 39, 5])),
            "kong georgs vej" : list(set([3, 7, 8, 5]))
        },
        branche_filter=['683220', '682010', '682020', '682030', '682040']
    )

    B_all = {"A": 0, "B": 0, "C": 0, "D": 0, "E": 0, "F": 0, "G": 0, "H": 0, "I": 0, "J": 0, "K": 0, "L": 0, "M": 0, "N": 0, "O": 0, "P": 0, "Q": 0, "R": 0, "S": 0, "X": 0, "NA": 0}

    branche = dict(zip(res, map(
        lambda x: list(map(
            lambda y: y.branche
        , x)), res.values()
    )))

    B_counts = dict(zip(branche, map(
        lambda x: sorted(list({**B_all, **dict(
            [ (i, x.count(i)) for i in sorted(set(x))]
        )}.items()), key=lambda x: x[0]), branche.values()
    )))

    # B_leg = list(set([(e.branche, e.branchenavn) for e in sum(list(res.values()), [])]))

    B_leg = list(map(lambda x: "{} - {}".format(x[0], x[1]), filter(lambda x: x[1] != "Koden er ikke kendt", sorted(list(set([lib.CVR.DB07(str(n)) for n in range(100)])), key=lambda x: x[0]))))

    A_all = {"0": 0, "1": 0, "2-4": 0, "5-9": 0, "10-19": 0, "20-49": 0, "50-99": 0, "100-199": 0, "200-49": 0, "500-99": 0, "1000-": 0}

    A_sort = {"0": 0, "1": 1, "2-4": 2, "5-9": 3, "10-19": 4, "20-49": 5, "50-99": 6, "100-199": 7, "200-49": 8, "500-99": 9, "1000-": 10}

    antal = dict(zip(res, map(
        lambda x: list(map(
            lambda y: y.antal_medarb
        , x)), res.values()
    )))

    A_counts = dict(zip(antal, map(
        lambda x: sorted(list({**A_all, **dict(
            [ (i, x.count(i)) for i in sorted(set(x))]
        )}.items()), key= lambda x: A_sort[x[:][0]]),
        antal.values()
    )))

    buffer = [
        A_counts,
        A_all,
        A_sort,
        B_counts,
        B_all,
        B_leg
    ]

    pickle.dump(buffer, open(path, "wb"))