wget -c http://ftp.squeak.org/4.3/Squeak4.3.zip
rm -r Squeak4.3
unzip Squeak4.3.zip
mv Squeak4.3/* .
../nsvm/nsvm Squeak4.3.image 00-Bootstrap.st
