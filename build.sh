date
wget -c http://ftp.squeak.org/4.3/Squeak4.3.zip
rm -r Squeak4.3
unzip Squeak4.3.zip
mv Squeak4.3/* .
../nsvm/nsvm -headless Squeak4.3.image 00-Bootstrap.st
hg --cwd ../newspeak tip > newspeaktip
hg --cwd ../nsboot tip > nsboottip
zip "nsboot-$(date +%F)" "nsboot-$(date +%F).image" "nsboot-$(date +%F).changes" newspeaktip nsboottip
mkdir ../bootimages
mv "nsboot-$(date +%F).zip" ../bootimages
rm "nsboot-$(date +%F).image" "nsboot-$(date +%F).changes" newspeaktip nsboottip
echo Build complete
date
