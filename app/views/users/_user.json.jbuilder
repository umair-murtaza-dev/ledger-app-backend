json.(user, :id, :email, :firstname, :lastname)
json.token user.generate_jwt
