object dmPok: TdmPok
  OldCreateOrder = False
  Height = 346
  Width = 397
  object RESTClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'https://pokeapi.co/api/v2'
    Params = <>
    Left = 32
    Top = 16
  end
  object RESTRequest: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <>
    Response = RESTResponse
    Left = 32
    Top = 72
  end
  object RESTResponse: TRESTResponse
    ContentType = 'application/json'
    Left = 32
    Top = 128
  end
end
