abstract class AuthServiceA {
  ///Optional init method for async code
  Future<void> init();

  ///Get oauth signing url
  Future<String> getSignInUrl();

  ///Signs the user our
  Future<void> signOut();

  ///Deletes a user account
  Future<void> deleteAccount();

  ///Retrives user accesstoken
  Future<String> get accessToken;
}
