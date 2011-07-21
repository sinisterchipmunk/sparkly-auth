module Auth
  class Version
    MAJOR = 1
    MINOR = 2
    PATCH = 1
    RELEASE = nil
    
    STRING = (RELEASE ? [MAJOR, MINOR, PATCH, RELEASE] : [MAJOR, MINOR, PATCH]).join(".")
  end
  
  VERSION = Version::STRING
end
