#!/bin/sh

# Dieses Bash-Script installiert die Homebridge auf einem Raspberry Pi
# created by cooper @ my.makesmart.net

INSTALLERURL=https://github.com/makesmartnet/homebridge-installer

# Willkommensnachricht
clear
echo
echo "Willkommen beim makesmart Homebridge-Installer!"
echo
echo "Du wirst im Laufe der Installation nach deinem Passwort gefragt."
echo "Das Passwort wird für root-Rechte zum Installieren der Software benötigt."
echo "Den Quellcode kannst du einsehen unter:"
echo ""
echo $INSTALLERURL
echo ""
echo "Zum Starten der Installation 'start' eingeben:"
# Auf Eingabe warten
read start


####################################


# Installation von Node

if which node > /dev/null
then
  # Node ist bereits installiert
  echo "Node ist bereits installiert. Bitte warten ..."
else
  # Hier wird Node installiert
  echo "Node wird installiert. Bitte warten ..."
  curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
  sudo apt install -y nodejs gcc g++ make python net-tools
  node -v
  sudo npm install -g npm
fi



###########################################

# Installation der Homebridge

# Installation von Homebridge und dem Plugin homebridge-config-ui-x
sudo npm install -g --unsafe-perm homebridge homebridge-config-ui-x

# Homebridge als Service einrichten, damit es beim Boot automatisch startet
sudo hb-service install --user homebridge




###########################################

# Config-Datei anpassen

# Dieses Bash-Script aktualisiert die Homebridge-config
# created by cooper @ my.makesmart.net

# Zuerst prüfen, ob die config.json exisitert

CONFIG=/var/lib/homebridge/config.json

if [[ -f "$CONFIG" ]]; then
    # jq installieren, um JSON zu bearbeiten
    sudo apt-get install jq -y

    # Bridge-PIN ändern
    sudo jq -c '.bridge.pin = "123-45-678"' "$CONFIG" > tmp.$$.json && sudo mv tmp.$$.json "$CONFIG"
    # Bridge-Name ändern
    sudo jq -c '.bridge.name = "makesmart-server"' "$CONFIG" > tmp.$$.json && sudo mv tmp.$$.json "$CONFIG"

    # Temp .json-File wieder löschen
    find . -name "*.json" -type f -print0 | xargs -0 /bin/rm -f

    # jq wieder deinstallieren
    sudo apt-get remove jq -y


  else
    echo "Leider ist ein Fehler bei der Installation aufgetreten:"
    echo "Die config.json liegt nicht im Standardpfad: $CONFIG"
fi


############################################

# Installation ist abgeschlossen
echo ""
echo "Deine Homebridge wurde installiert. Du erreichst sie über:"
echo ""
# Hier nur die lokale IP-Adresse des Raspberry Pis aufrufen
ip_adress=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

echo ""
echo "http://""$ip_adress"":8581/"
echo ""
echo "Benutzername: admin"
echo "Passwort: admin"
echo ""
echo "Bitte ändere nach dem ersten Login deine Zugangsdaten."
echo "Einstellungen -> Benutzerkonten -> Administrator"

# END SCRIPT
