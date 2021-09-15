unit UnitMenuPerfil;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TFFMenuPerfil = class(TForm)
    btnVoltarConta: TImage;
    imgPerfil: TCircle;
    lblNomeUsu: TLabel;
    lblEmailUsu: TLabel;
    lblLancamentos: TLabel;
    lblDesconect: TLabel;
    lblPerfil: TLabel;
    lblCategorias: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FFMenuPerfil: TFFMenuPerfil;

implementation

{$R *.fmx}

end.
