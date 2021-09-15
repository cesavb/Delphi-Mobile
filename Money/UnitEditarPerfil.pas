unit UnitEditarPerfil;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit;

type
  TFFEditarPerfil = class(TForm)
    Layout5: TLayout;
    lblEditPerfil: TLabel;
    btnVoltarConta: TImage;
    imgSalve: TImage;
    imgPerfil: TCircle;
    lblNomeUsu: TLabel;
    lblEmailUsu: TLabel;
    Layout1: TLayout;
    Layout4: TLayout;
    rrLogin: TRoundRect;
    edtName: TEdit;
    Layout2: TLayout;
    RoundRect1: TRoundRect;
    edtEmail: TEdit;
    Layout3: TLayout;
    RoundRect2: TRoundRect;
    edtSenha: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FFEditarPerfil: TFFEditarPerfil;

implementation

{$R *.fmx}

end.
