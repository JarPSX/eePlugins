try:
    from Components.Converter.MSNWeatherThingSpeak import MSNWeatherThingSpeak as j00zekMSNWeatherThingSpeak
except Exception:
    try:
        from Components.Converter.FhromaMSNWeatherThingSpeak import FhromaMSNWeatherThingSpeak as j00zekMSNWeatherThingSpeak
    except Exception:
        from Components.Converter.j00zekMissingConverter import j00zekMissingConverter as j00zekMSNWeatherThingSpeak
