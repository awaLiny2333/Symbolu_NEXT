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
  @State selected: number = 0;
  // Data
  data: LinysSymbolDataSource = new LinysSymbolDataSource(allSymbols);

  build() {
    Column({ space: 10 }) {
      WaterFlow() {
        LazyForEach(this.data, (s: linysSymbol, idx: number) => {
          LinysSymbolDisplay({
            symbol: s
          })
            .onClick(() => {
              this.selected = idx;
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

      Row({ space: 10 }) {
        // Blank()
        LinysCapsuleButton({ text: "No. " + this.selected.toString() })
        Blank()
        LinysCapsuleButton({ text: " " + allSymbols[this.selected].char + " ", fontSize: 26 })
        LinysCapsuleButton({ text: allSymbols[this.selected].unicode })
        LinysCapsuleButton({ text: allSymbols[this.selected].name })
        // Blank()
        // LinysCapsuleButton({ text: " 󰆝 ", fontSize: 26, allowCopy: false })
      } // Operations
      .width('100%')

      TextInput({ text: this.inputText })// Search Blank
        .onChange((newText) => {
          this.inputText = newText;
        })
        .onSubmit(() => {
          this.searchFor(this.inputText);
        })
    }
    // .backgroundColor($r('app.color.start_window_background'))
    .padding({ left: 20, right: 20 })
    .height('100%')
    .width('100%')
    .onAreaChange((o, n) => {
      this.on_main_area_change(o, n);
    })
  }

  searchFor(key: string) {
    console.log('[Woof]Searching for key: ' + key);
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
  // Colors
  @Prop colors: ResourceColor = $r('app.color.font_color_title');
  @Prop fontWeight: FontWeight = FontWeight.Normal;

  build() {
    Text(this.symbol.char)
      .width(50)
      .height(50)
      .fontWeight(this.fontWeight)
      .fontSize(50)
      .fontColor($r('app.color.font_color_title'))
      .clickEffect({ level: ClickEffectLevel.LIGHT })
    // .animation({ duration: 300 }
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