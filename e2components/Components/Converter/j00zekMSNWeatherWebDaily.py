try:
    from Components.Converter.MSNWeatherWebDaily import MSNWeatherWebDaily as j00zekMSNWeatherWebDaily
except Exception:
    try:
        from Components.Converter.FhromaMSNWeatherWebDaily import FhromaMSNWeatherWebDaily as j00zekMSNWeatherWebDaily
    except Exception:
        from Components.Converter.j00zekMissingConverter import j00zekMissingConverter as j00zekMSNWeatherWebDaily 
