# hotdog-or-not-dl-ios-sample
This is an iOS application that demonstrates deep learning and CoreML models integration into an iOS app. The app exposes the CoreML model from https://github.com/BusineswareTech/hotdog-or-not-dl-training repo.

## How it works
* The application scans the scene through the camera in real-time.
* Once a hotdog is detected, the app shows an indicator in the bottom right corner, which can glow. The glow intensity depends on the probability of the object is being a hotdog. A more intensive glow means a higher probability.

## What has been used
* CoreML. 
* Vision Framework.

## Notes
* There is a connection to the local backend in the sample. It’s not required for the app to run.
