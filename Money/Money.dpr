program Money;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FLogin},
  uFormat in '..\Fontes\Units\uFormat.pas',
  UnitPrincipal in 'UnitPrincipal.pas' {FPrincipal},
  u99Permissions in '..\Fontes\Units\u99Permissions.pas',
  UnitLancamentos in 'UnitLancamentos.pas' {FFLancamentos},
  UnitLancamentoNovo in 'UnitLancamentoNovo.pas' {FFLancamentoNovo},
  UnitCategorias in 'UnitCategorias.pas' {FFCategoria},
  UnitNovaCategoria in 'UnitNovaCategoria.pas' {FFNovaCat},
  UnitDM in 'UnitDM.pas' {dm: TDataModule},
  cCategoria in 'cCategoria.pas',
  UnitSplash in '..\MoneyTest\UnitSplash.pas' {FrmSplash},
  cLancamento in 'cLancamento.pas',
  UnitMenuPerfil in 'UnitMenuPerfil.pas' {FFMenuPerfil},
  UnitEditarPerfil in 'UnitEditarPerfil.pas' {FFEditarPerfil};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmSplash, FrmSplash);
  Application.CreateForm(TFFMenuPerfil, FFMenuPerfil);
  Application.CreateForm(TFFEditarPerfil, FFEditarPerfil);
  Application.Run;
end.
