nsboot
======

The Smalltalk changesets and packages needed to bootstrap a [Newspeak](http://www.newspeaklanguage.org/) image from a [Squeak](http://www.squeak.org/) image. Newspeak currently uses Squeak 5.0.

```
mkdir Newspeak
cd Newspeak
hg clone https://bitbucket.org/newspeaklanguage/newspeak
hg clone https://bitbucket.org/newspeaklanguage/nsboot
cd nsboot
./build32.sh
```
