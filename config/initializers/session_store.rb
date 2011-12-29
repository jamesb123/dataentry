# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_DataEntry_session',
  :secret      => '6effeaceec7d08cdfd4b6be9cd33e17d276e47e832ee3908693eb43c11d07dbc818370aaad085f6689134da73796ea2dd304db5a8045ea4f073dbb33f17e6583'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
