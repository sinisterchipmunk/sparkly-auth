# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_auth_session',
  :secret      => 'b2d587d6cc349db2179db5f5c639b5cc02aa1af5af5004a347abdde9637be5cd8cbb22cc40f9990092c25cbd6b93f5d707ccf54f872c20aa1512c56807cd6cb0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
