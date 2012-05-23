ListenRate is a Sinatra web application designed to help you keep track of your
average music listening habits in songs per day. It authenticates to your
[Last.fm][lastfm] account for song play counts and other data.

## Setup

ListenRate comes with a Gemfile, so if you have [Bundler][bundler] installed,
you can install required gems simply by running:

    bundle install

Otherwise, you will need the following gems: `sinatra`, `haml`, `sass`,
`lastfm`, `parseconfig`, and `data_mapper`.

Once you have all your gems installed, you will need to set up an application
account with Last.fm. Head over to your [API account page][apiaccount] and fill
in the required information. (I recommend you don't call your app ListenRate; at
least come up with some username-specific distinguisher, to avoid collisions.)
Once you're set up, get the API key and secret from that page and create a new
file called `lastfm-keys.conf` that looks like:

    apikey = your-apikey-here
    secret = your-secret-here

Make sure to protect your API secret appropriately - setting permissions to
`0600` on the `lastfm-keys.conf` file is a good start.

## Usage

Once you have the app configured, launch it either with your favorite Ruby
middleware or simply by running:

    ruby listenrate.rb

Access the app's home page and enter your username. You'll be redirected to
Last.fm once more to authorize the app for your own account; do so, and you
should see your own statistics pop up on the screen. Happy listening!

## Known issues

There is one major outstanding issue, which is the distinction between users of
the ListenRate app and Last.fm user accounts. Right now, the two are conflated a
little bit internally, so exposing ListenRate to the world to use may not work
quite right (or may overrun your API usage limits). It's recommended that you
use ListenRate only for your own user account at present.

For more technical details, see the [issue tracker][issues].


[lastfm]: http://www.last.fm
[bundler]: http://www.gembundler.com
[apiaccount]: http://www.last.fm/api/account
[issues]: https://github.com/lithium3141/ListenRate/issues
