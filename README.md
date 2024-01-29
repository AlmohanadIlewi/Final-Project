# Social Netzwerk Backend CICD Pipeline
Dieses Repository enthält die Implementierung einer Continuous Integration and Continuous Deployment (CICD) Pipeline für das Backend eines Social Netzwerks. Die Pipeline umfasst das Sammeln von Lambda-Funktionen, das Erstellen von ZIP-Archiven und das Bereitstellen dieser Archive auf Amazon S3.

# Skripte
Das Skript durchsucht alle Verzeichnisse in ./lambda-functions/ und erstellt ein JSON-Objekt.

## lsdirs.sh
Das Bash-Skript lsdirs.sh wird verwendet, um Lambda-Funktionen zu identifizieren und ein JSON-Objekt mit den Lambda-Definitionen zu erstellen.

# Bash-Skript lsdirs.sh
Das Bash-Skript lsdirs.sh wird verwendet, um die Lambda-Funktionsverzeichnisse oder (zu identifizieren) zu finden, Informationen aus den lambda_def.json-Dateien zu extrahieren und ein JSON-Objekt mit den Lambda-Definitionen zu erstellen.

# GitHub Actions YAML-Code deploylamdazips3.yml
Die GitHub Actions YAML-Datei deploylamdazips3.yml definiert die CICD-Pipeline in GitHub Actions. 

## Erläuterungen:

jobs: Definiert die verschiedenen Jobs in der Pipeline.
Collect-Lambda-Functions: Der Job sammelt die Lambda-Funktionen und erstellt eine JSON-Datei lambdi.json.
build: Der Job erstellt ZIP-Archive für jede Lambda-Funktion.
deploy: Der Job lädt die erstellten ZIP-Archive auf Amazon S3 hoch.

### - name: List Lambda Functions bis ... cat lambdi.json
- Der Job verwendet das Bash-Skript lsdirs.sh zum Sammeln der Lambda-Definitionen und erstellt die lambdi.json-Datei.

### - name: Deploy Lambdi.json to S3

- Der Job lädt die erstellte lambdi.json-Datei auf Amazon S3 hoch.

### - name: Zip Lambda function bis ... ls

Der Job erstellt ZIP-Archive für jede Lambda-Funktion, indem er npm-Abhängigkeiten installiert und die notwendigen Dateien zippt.
Dies sind grundlegende Erläuterungen zu deinem Bash-Skript und dem GitHub Actions YAML-Code. Wenn du spezifische Fragen zu bestimmten Teilen des Codes hast, lass es mich bitte wissen!