import os

class BaseConfig(object):
    DEBUG = False
    TESTING = False
    FUSEKI_ADDRESS = 'localhost:3030'


class DevelopmentConfig(BaseConfig):
    DEBUG = True
    TESTING = False


class TestConfig(BaseConfig):
    DEBUG = False
    TESTING = True

class ProductionConfig(BaseConfig):
    DEBUG = False
    TESTING = False
    FUSEKI_ADDRESS = 'chiron:3030'

config = {
    "development": "config.DevelopmentConfig",
    "test": "config.TestConfig",
    "production": "config.ProductionConfig"
}


def configure_app(app):
    config_name = os.getenv('FLASK_CONFIGURATION', 'development')
    app.config.from_object(config[config_name])
