import { linysSymbol } from '../objects/linysSymbol';

@Component
struct LinysSymbolDisplay {
  @Prop symbol: linysSymbol;
  @Link selected: linysSymbol;
  @Prop fontSize: number = 50;
  // Settings
  @StorageLink('symbolRenderingStrategy') symbolRenderingStrategy: number = 0;
  @StorageProp('symbolColors') symbolColors: ResourceColor[] = [$r("app.color.accent")];
  @StorageProp('symbolFontWeight') symbolFontWeight: number = 200;

  build() {
    Column({ space: 10 }) {
      SymbolGlyph($r('sys.symbol.'.concat(this.symbol.name)))
        .fontColor(this.symbolColors)
        .fontWeight(this.symbolFontWeight)
        .fontSize(this.fontSize)
        .width(this.fontSize)
        .height(this.fontSize)
        .renderingStrategy(this.symbolRenderingStrategy)
        .clickEffect({ level: ClickEffectLevel.LIGHT })
        .onClick(() => {
          this.selected = this.symbol;
        })
    }

  }
}

export default LinysSymbolDisplay;