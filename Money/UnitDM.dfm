object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 277
  Width = 339
  object conn: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\cesar.baganha\Documents\Treinamento\Aulas Mobi' +
        'le\Money\DB\banco.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=sQLite')
    LoginPrompt = False
    Left = 80
    Top = 64
  end
end
