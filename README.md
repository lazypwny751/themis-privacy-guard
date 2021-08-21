# themis-privacy-guard (tpg) 1.0.0
themis privacy guard library - themis

## Instalation

### way 1:
```bash
git clone https://github.com/lazypwny751/themis-privacy-guard.git && cd themis-privacy-guard && sudo make install
```

### way 2:
install the [themis](https://github.com/ByCh4n-Group/themis) projact then just add the [standart themis library repository](https://github.com/ByCh4n-Group/regular-modules) and just type **sudo themis install tpg**

### way 3:
also you can use the [binary packages](https://github.com/lazypwny751/themis-privacy-guard/releases)

## Usage

#### __tpg-dep-check
The '__tpg-dep-check' is the function that detects the programs required for tpg to run, 
it doesn't need to use manual, other functions already use this __tpg-dep-check at the right time

#### __get-priv-key
The '__get-priv-key' function allows you to manipulate your private key. 
You can do 2 operations with arguments 1. You can print 
The second argument is the 'write' argument. Its usage is as follows:
'__get-priv-key write <directory-path>' saves your personal key 
in a file named <hostanme>.priv in the specified directory 

#### __get-pub-key
'__get-pub-key' function can be used with 2 arguments 1. 'print', that is, 
it displays your public key on the screen 2. argument is 'write' argument,
which is used as '__get-pub-key write <directory-path>' to the specified directory 
It saves your public key in a file named <hostname>.pub

#### tpg-sign-file
The 'gpg-sign-file' function is used with one or more parameter(s)
so you sign the specified files example 'tpg-sign-file test.tar.gz'

#### tpg-check-file
The 'tpg-check-file' function is used with one or more parameters.
You enter the files you want to verify as a parameter, 
but before that you must enter a public key as the first parameter, 
for example:'tpg-check-file mypubkey.pub test.tar.gz'

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[GPLv3](https://choosealicense.com/licenses/gpl-3.0/)
