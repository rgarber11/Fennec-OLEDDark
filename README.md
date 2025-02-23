# Fennec-OLEDDark

Shamelessly copied from [Ironfox-OLEDDark](https://github.com/ArtikusHG/Ironfox-OLEDDark). However, I found the changes IronFox makes to stock Firefox for Android more annoying than helpful, so this repo does the same exact changes but to a more faithful fork. As such, it will be less privacy-conscious than Ironfox, but come with Google Search.

# How does this work?

As Building the entire browser from source just to change two lines in the XML would be silly, this repo (and ArtikusHG's repo) just edits the values of colors to be Black rather than gray. (Note: if someone who can navigate Firefox's repo could tell me how to change the Private Browsing to be darker, I'd be grateful.)

# How to use

This repo can be imported into Obtainium to directly download patched updates as soon as they're released. Feel free to use this on your own device, or modify it to patch other things. Security should not be a huge concern, since new builds are automated and run every 24 hours (unless you don't trust me, because I do have to sign this with my own keys - in this case just fork the repo and add your own action secrets).
