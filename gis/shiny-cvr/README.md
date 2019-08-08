# Vask og udstilling af historisk adressedata fra CVR

## API beskrivelser

### lib.CVR.get

get() forventer input i dette format:

```python
{
    "vejnavn": [husnr, ...],
    .,
    .,
    .
}
```

Hvor vejnavn er en tekststreng med et vejnavn i **små** bokstaver.
husnr er heltal, og der kan være arbitrert mange per vej.
Hvis der kun skal slås et enkelt husnr op, er det vigigt at det stadig er en **liste**, ie.
```python
# DO
"vejnavn" : [1]
# DON'T
"vejnavn" : 1
```

---

## Eksempler

### lib.Parser.Parser

```python
from lib.Parser import Parser

adrs = ["Fiskergade 5-6", "Borger gade 4, STTV, 6000 Kolding"]

p = Parser()
p.parse(adrs)

with open("test.geojson", "w") as f:
    f.write(p.ab_as_geojson())
```

---

### lib.CVR.get

```python
from lib.CVR import get

#get() returns a dictionary with years for keys and lists of Virksonhed-objects
res = get(
        {
            "mariendalsvej": [10, 11, 12, 14, 15],
            "smallegade": [20, 49]
        }
    )

h = "CVR" + " "*8 + "Navn" + " "*(71) + "Branche" + " "*2 + "L" + " "*7 + "M"
for y in res:
    print(f"\n---[{y}]---\n")
    print(h)
    for virk in res[y]:
        print(virk)
```
