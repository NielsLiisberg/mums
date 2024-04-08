
#!/bin/sh
## Super simple Niels Liisberg version of install freeware:

function dependencies {
  
  if grep -Fxq "$1"  dependencies/deps.txt
  then
    echo "$rec exists"
  else
    echo "$1" >> dependencies/deps.txt
    dependencies=$(echo $1 | sed 's/.rpm/.deps/g')

    tempdep=$(mktemp) 
    echo "dependencies $dependencies"
    link="ftp://www.oss4aix.org/rpmdb/deplists/aix72/$dependencies"

    echo "$link"
    wget --quiet -O $tempdep $link

    echo "Installing components for $1:"
    cat "$tempdep"

    mkdir -p rpm
    while read rec
    do
      if grep -Fxq "$rec"  dependencies/deps.txt
      then
        echo "$rec exists"
      else
        echo "$rec" >> dependencies/deps.txt
        dependencies $rec
      fi
    done < "$tempdep" 
    rm $tempdep
  fi
}

function list  {
  wget --quiet --no-remove-listing ftp://www.oss4aix.org/RPMS/
  cat ".listing" | grep -i $1
  rm  ".listing"
}

function versions   {
  wget  --quiet --no-remove-listing ftp://www.oss4aix.org/RPMS/$1/
  cat ".listing" 
  #while read rec
  #do
  #  echo $rec 
  #done < ".listing" 
  echo "Install by giving full RPM name to:"
  echo "./freeware.sh install $1 [rpm name]"

}

function install  {
  mkdir -p dependencies 
  touch dependencies/deps.txt
  dependencies $1
  rm  tmp.* ## why will it not delete in function ?? 

  # load RPM's we don have yet
  while read rec
  do
    echo $rec 
    wget  -P rpm/ --no-remove-listing ftp://www.oss4aix.org/everything/RPMS/$rec
  done < "dependencies/deps.txt" 

  # install RPM's we don have yet
  while read rec
  do
    echo $rec 
    rpm -i --ignoreos --ignorearch --nodeps --replacepkgs -hUv rpm/$rec
  done < "dependencies/deps.txt" 


  ###folder=$(echo $1 | sed 's/-.*//g')
  ###echo "Folder $folder"
  ###mkdir -p rpm
  ###wget -P rpm/ ftp://www.oss4aix.org/RPMS/$folder/$1
  ##rpm -i --ignoreos --ignorearch --nodeps --replacepkgs -hUv rpm/$1
}

function uninstall  {
   rpm -e rpm/$1
}
function show {
   rpm -qlp rpm/$1
}
function clean  {
   rm -r rpm 
   rm -r download 
   rm -r dependencies
}

function help {
  echo "Usage"
  echo "mums clean"
  echo "mums list [packagename]"
  echo "mums versions packagename"
  echo "mums install rpm"
  echo "mums show rpm"
  echo "mums uninstall rpm"
}



case "$1" in
  "")
  help
  ;;
  "clean")
  clean 
  ;;
  "list")
  list $2
  ;;
  "versions")
  versions $2
  ;;
  "install")
  install $2
  ;;
  "show")
  show $2
  ;;
  "uninstall")
  uninstall $2
  ;;
  *)
  help
  ;;
esac