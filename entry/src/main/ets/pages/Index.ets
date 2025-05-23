import { allSymbols, linysSymbol } from '../objects/linysSymbol';
import LinysSymbolDataSource from '../objects/SymbolDataSource';
import { copy } from '../utils/clipboard_tools';

@Entry
@Component
struct Index {
  // Environment
  @StorageLink('tablet_mode') tablet_mode: boolean = false;
  @StorageLink('screen_width') screen_width: number = 0;
  @StorageLink('screen_height') screen_height: number = 0;
  // UI
  @State inputText: string = "";
  @State symbolTest: Resource = $r('sys.symbol.camera_slash_fill');
  @State selected: linysSymbol = allSymbols[0];
  // Data
  data: LinysSymbolDataSource = new LinysSymbolDataSource(allSymbols);

  build() {
    Column({ space: 10 }) {
      WaterFlow() {
        LazyForEach(this.data, (s: linysSymbol) => {
          LinysSymbolDisplay({
            symbol: s,
            selected: this.selected
          })
        }, (s: linysSymbol) => {
          return s.unicode;
        })
      } // Symbols
      .edgeEffect(EdgeEffect.Spring)
      .width('100%')
      .layoutWeight(1)
      .columnsTemplate("1fr ".repeat(Math.ceil(this.screen_width / 75)))
      .columnsGap(15)
      .rowsGap(15)
      .scrollBar(BarState.On)

      Scroll() {
        Row({ space: 10 }) {
          LinysCapsuleButton({ text: "No. " + this.selected.id.toString() })
          LinysCapsuleButton({ text: " " + this.selected.char + " ", fontSize: 26 })
          LinysCapsuleButton({ text: this.selected.unicode })
          LinysCapsuleButton({ text: this.selected.name })
        } // Operations
      }
      .width('100%')
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)

      Row({ space: 10 }) {
        TextInput({ text: this.inputText })// Search Blank
          .layoutWeight(1)
          .onChange((newText) => {
            this.inputText = newText;
          })
          .onSubmit(() => {
            this.searchFor(this.inputText);
          })
        SymbolGlyph($r('sys.symbol.arrow_counterclockwise'))// Reset Button
          .fontColor([$r('app.color.font_color_title')])
          .fontSize(36)
          .onClick(() => {
            this.inputText = '';
            this.searchFor('');
          })
      }
    }
    .padding({ left: 20, right: 20, top: 10 })
    .height('100%')
    .width('100%')
    .onAreaChange((o, n) => {
      this.on_main_area_change(o, n);
    })
  }

  searchFor(key: string) {
    console.log('[Woof]Searching for key: ' + key);
    let searchResult: linysSymbol[] = [];
    for (let index = 0; index < allSymbols.length; index++) {
      const element = allSymbols[index];
      if (element.name.toUpperCase().includes(key.toUpperCase())) {
        searchResult.push(element);
      }
    }
    this.data.setData(searchResult);
  }

  on_main_area_change(_old: Area, n: Area) {
    this.screen_width = n.width as number;
    this.screen_height = n.height as number;
    this.tablet_mode = this.screen_width > 500;
  }
}

@Component
struct LinysSymbolDisplay {
  @Prop symbol: linysSymbol;
  @Link selected: linysSymbol;
  // Colors
  @Prop colors: ResourceColor = $r('app.color.font_color_title');
  @Prop fontWeight: FontWeight = FontWeight.Normal;

  build() {
    Column({ space: 10 }) {
      // SymbolGlyph($r('sys.symbol.beido'))
      // SymbolGlyph($r('sys.symbol.'.concat(this.symbol.name)))
      //   .fontColor([$r('app.color.font_color_title')])
      Text(this.symbol.char)
        .fontColor($r('app.color.font_color_title'))
        .width(50)
        .height(50)
        .fontWeight(this.fontWeight)
        .fontSize(50)
        .clickEffect({ level: ClickEffectLevel.LIGHT })
        .onClick(() => {
          this.selected = this.symbol;
        })
    }

  }
}

@Component
struct LinysCapsuleButton {
  @Prop text: ResourceStr = "   ";
  @Prop fontSize: number = 22;
  @Prop allowCopy: boolean = true;

  aboutToAppear(): void {
    // Preprocess of text
    this.text = this.text == "" ? "¯\\_(ツ)_/¯" : this.text;
  }

  build() {
    Button(this.text)
      .type(ButtonType.Capsule)
      .backgroundColor($r('app.color.block_color'))
      .fontColor($r('app.color.font_color_title'))
      .fontSize(this.fontSize)
      .fontWeight(FontWeight.Medium)
      .backgroundColor($r('app.color.block_color'))
      .clickEffect({ level: ClickEffectLevel.LIGHT })
      .onClick(() => {
        if (this.allowCopy && typeof this.text == "string") {
          copy(this.text as string);
        }
      })
  }
}