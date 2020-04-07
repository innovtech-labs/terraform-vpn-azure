# Template Terraform for Azure

## Présentation

Suite au confinement lié au COVID-19, beaucoup d'entreprises n'ont pas pu anticiper convenablement l'extension de leur
connexion VPN afin que tous leurs collaborateurs puissent se connecter en VPN et travailler sereinement.
Au final, on s'aperçoit que l'on arrive à une saturation du nombre de connexions VPN autorisées par le matériel ou en
terme de licences, et qu'une partie des employés ne peuvent tout simplement pas se connecter. Cela engendre
potentiellement du chômage partiel ou une nécessité de faire déplacer les travailleurs.
 
Pour tenter de palier à cela, nous proposons de mettre à disposition une série de scripts Terraform, vous permettant de
créer un ensemble de ressources dans le cloud Azure de Microsoft, qui servira de passerelle, entre les clients VPN et
votre réseau On-Premise.

## Pré-requis

Avant d'exécuter le déploiement de ces ressources, quelques pré-requis sont nécessaires :
* Avoir un compte ou une souscription dans Azure
* Installer [Azure CLI](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli?view=azure-cli-latest)
* Créer un [compte de service Azure](https://docs.microsoft.com/fr-fr/azure/active-directory/develop/howto-create-service-principal-portal) qui sera utiliser par la suite pour le déploiement
* Installer l'outil [Terraform](https://www.terraform.io/downloads.html) sur votre poste

## Utilisation

Après avoir fait le nécessaire dans la partie pré-requis, il suffit de cloner le dépôt, modifier les fichiers suivantes :
* _1-main.tf_ : il suffira de renseigner les informations associées à votre compte de service Azure
* _variables.tf_ : il faudra définir les plages réseaux que vous souhaitez utiliser dans Azure. **ATTENTION : il ne faut pas utiliser les
mêmes que dans votre réseau en local (On-Premise)**.
* _2-hub-vnet.tf_ : il sera nécessaire de modifier la valeur de **public_cert_data** afin d'y mettre votre propre certificat.

Le déploiement se fera via les commandes Terraform habituelles
 ```shell
# Initialisation du projet Terraform sur votre poste
terraform init
# Validation des scripts Terraform
terraform validate
# Planification des scripts Terraform dans Azure
terraform plan
# Déploiement des scripts Terraform dans Azure
terraform apply
# Destruction des ressources Azure déployées par les scripts Terraform
terraform destroy
```

## Et ensuite ?

Pour le moment, les scripts sont fonctionnels uniquement avec Azure. Si jamais, un équivalent pour Google et/ou AWS était
nécessaire, n'hésitez pas à ouvrir une demande dans notre GitHub.

## Mentions légales

INNOVTECH FOURNIT CETTE DOCUMENTATION ET CES SCRIPTS "EN L'ETAT", SANS AUCUNE GARANTIE D'AUCUNE SORTE, Y COMPRIS, DE
MANIERE NON LIMITATIVE, TOUTE GARANTIE IMPLICITE DE QUALITE MARCHANDE, D'ADEQUATION A UN USAGE PARTICULIER ET D'ABSENCE
D'INFRACTION. EN AUCUN CAS, INNOVTECH NE POURRA ÊTRE TENU POUR RESPONSABLE EN CAS DE PERTE OU DE DOMMAGE, DIRECT OU
INDIRECT, SUBI PAR L'UTILISATEUR FINAL OU PAR UN TIERS, ET RÉSULTANT DE L'UTILISATION DE CETTE DOCUMENTATION, CES SCRIPTS,
NOTAMMENT TOUTE PERTE DE PROFITS OU D'INVESTISSEMENTS, INTERRUPTION D'ACTIVITÉ, PERTE DE DONNÉES OU DE CLIENTS, ET CE
MÊME DANS L'HYPOTHÈSE OÙ INNOVTECH AURAIT ÉTÉ EXPRESSÉMENT INFORMÉ DE LA POSSIBILITÉ DE TELS DOMMAGES OU PERTES.