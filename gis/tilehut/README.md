# Inden første start

Inden første start skal der genereres nye host keys.

Kør `init.sh` scriptet.

## Opsætning af en ny bruger

Denne guide går ud fra at brugeren bruger windows.

Hvis brugeren kører Linux, bør de selv kunne regne ud hvordan det oversættes.

### Installering af dependencies

Der er to nødvendige dependencies:

* WinSCP (Eller en anden ftp client)
* OpenSSH

WinSCP kan installeres fra deres hjemmeside, mens OpenSSH kan installeres for sig eller igennem git for windows. På nogle Windows 10 distributioner shipper powershell med OpenSSH.

### Nøglegenerering

Et nyt nøglepar genereres med

```shell
ssh-keygen -t rsa -b 4096
```

Du vil undervejs blive prompted for et password til privatnøglen. Det er vigtigt at du husker dette password, da det ikke kan blive recovered.

### Upload af offentlignøglen

Nøglen skal uploades til serveren. Dette kræver at du har ssh adgang til serveren.

```shell
scp <din-nøgle>.pub root@app.frb-data.dk:/opt/prod-app1-deployment/gis/tilehut/pub_keys/
```

Fra serveren i mappen `/opt/prod-app1-deployment/gis/tilehut/` køres kommandoen `make re-ftp` for at opdatere ftp-serverens keystore.

### Oprettelse af server i WinSCP

#### 1.  `New Site` vælges i menuen til venstre.

#### 2. `File protocol` = SFTP

#### 3. `Hostname` = th.frb-data.dk

#### 4. `Port number` = 2222

#### 5. `User name` = gis

#### 6. `Password` tomt

#### 7. I `Advanced` under `SSH -> Authentication` sættes `Private key file` til din privat nøgle

#### 8. Du promptes om, hvorvidt nøglen skal laves om til en .ppk-nøgle; Svar ja
