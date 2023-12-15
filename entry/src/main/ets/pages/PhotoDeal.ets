import image from '@ohos.multimedia.image';
import router from '@ohos.router';
import Logger from '../common/logutils';
import { save } from '../common/encodeutils';
import picker from '@ohos.file.picker';
import common from '@ohos.app.ability.common';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
@Entry
@Preview
@Component
struct PhotoDeal {
  //图片信息
  private image_size: Position = { x: 0, y: 0 } //图片大小
  private image_pos: Position = { x: 0, y: 0 } //图片位置
  @State pxImage: PixelMap = undefined //图片
  private scales: number = 1 //图片的缩放比例
  private angle: number = 0 //图片的旋转角度
  //Canvas 初始化
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  //绘制模式
  private mode: string = 'drag'
  //保留所有操作的初始点
  @State x_start: number = 0;
  @State y_start: number = 0;
  //保留所有操作
  /*
   * 数据格式约定
   * type // 元素类型 option: 'image',''line','rect','text'
   * x    // 元素 x 坐标
   * y    // 元素 y 坐标
   * w    // 元素宽度
   * h    // 元素长度
   * scale  // 缩放比列
   * angle  // 旋转角度
   * img    // 图片对象
   * */
  private elements = []
  //避免由于异步操作，导致图片无法初始化加载
  private isInit: boolean = false;
  //记录移动开始的时间
  private time_start: Date = new Date()
  //文本编辑开关
  @State text_editor: boolean = false
  //拖动开关
  private dragging: boolean = false
  //线条数量
  private line_num: number = 0
  private Log = new Logger("PhotoDeal")
  @State text_content: string = ''
  private text_area: Area
  private rect_width: number = 0
  private rect_height: number = 0

  aboutToAppear() {
    let context = getContext(this)
    try {
      context.resourceManager.getMediaContent($r('app.media.label').id).then(value => {
        const imageSource = image.createImageSource(value.buffer)
        imageSource.createPixelMap().then(pixelMap => {
          this.pxImage = pixelMap;
          this.image_size.x = pixelMap.getBytesNumberPerRow() / 4
          this.image_size.y = pixelMap.getPixelBytesNumber() / pixelMap.getBytesNumberPerRow()
          this.onDraw();
        }).catch(error => {
          console.log("getMediaContent  error is " + error);
        });
      }).catch(error => {
        console.log("getMediaContent promise error is " + error);
      });
    } catch (error) {
      console.error(`promise getMediaContent failed, error code: ${error.code}, message: ${error.message}.`)
    }
    let contexts = getContext(this) as common.UIAbilityContext
    let atManager = abilityAccessCtrl.createAtManager()
    try {
      atManager.requestPermissionsFromUser(contexts, ['ohos.permission.READ_MEDIA','ohos.permission.WRITE_MEDIA']).then((data) => {
        this.Log.info(`data: ${JSON.stringify(data)}`)
      }).catch((err) => {
        this.Log.info(`err: ${JSON.stringify(err)}`)
      })
    } catch (err) {
      this.Log.info(`catch err->${JSON.stringify(err)}`);
    }
  }

  build() {
    Column() {
      Row() {
        Button() {
          Text('取消').height(40).width('50%')
        }.onClick(()=>{
          router.back()
        })

        Blank()
        Button() {
          Text('确认').height(40).width('50%')
        }.onClick(()=>{
          AlertDialog.show(
            {
              title: '',
              message: '是否要保存当前的更改',
              autoCancel: true,
              alignment: DialogAlignment.Center,
              gridCount: 4,
              primaryButton: {
                value: '取消',
                action: () => {
                  try {
                    let PhotoSelectOptions = new picker.PhotoSelectOptions();
                    PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
                    PhotoSelectOptions.maxSelectNumber = 5;
                    let photoPicker = new picker.PhotoViewPicker();
                    photoPicker.select(PhotoSelectOptions, (err, PhotoSelectResult) => {
                      if (err) {
                        console.error('PhotoViewPicker.select failed with err: ' + err);
                        return;
                      }
                      console.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
                    });
                  } catch (err) {
                    console.error('PhotoViewPicker failed with err: ' + err);
                  }
                  console.info('Button-clicking callback')
                }
              },
              secondaryButton: {
                value: '确定',
                action: () => {
                  save(this.context.getPixelMap(Number(this.image_pos.x),Number(this.image_pos.y),Number(this.image_size.x),Number(this.image_size.y)))
                  console.info('Callback when the second button is clicked')
                }
              },
              cancel: () => {
                console.info('Closed callbacks')
              }
            }
          )
        })
      }.height(40)

      Divider().color(Color.White)
      Stack() {
        Canvas(this.context)
          .width('100%')
          .height('85%')
          .onReady(() => {
            this.isInit = true;
            this.Log.info(`Ready!`)
            this.onDraw()
          })
          .backgroundColor(Color.White)
          .border({ width: 2, color: Color.Red })
          .onTouch((event) => {
            this.Log.info(`mode is ${this.mode}`)
            // x坐标
            const x = event.touches[0].x
            // y坐标
            const y = event.touches[0].y

            switch (this.mode) {
              case 'line': { //画线模式
                if (this.isMouseOnImage(x, y) == false) {
                  if (this.dragging) {
                    this.line_num++
                    this.dragging = false
                  }
                  return;
                }
                switch (event.type) {
                  case TouchType.Down: { // 手指按下时
                    this.context.beginPath() // 创建一个新的绘制路径
                    this.context.moveTo(x, y) // 创建一个新的绘制路径
                    this.x_start = x
                    this.y_start = y
                    this.dragging = true
                  }
                    break

                  case TouchType.Move: {
                    this.context.lineWidth = 2
                    this.context.lineTo(x, y) // 设置移动点
                    this.context.stroke() // 进行路径绘制
                    this.elements.push({
                      type: 'line',
                      color: '#000',
                      x: this.x_start,
                      y: this.y_start,
                      w: x,
                      h: y,
                      id: this.line_num
                    })
                    this.Log.info(`elements length: ${this.elements.length}`)
                    this.x_start = x
                    this.y_start = y
                  }
                    break

                  case TouchType.Up: { // 手指抬起时
                    this.context.lineTo(x, y) // 设置移动点
                    this.context.stroke() // 进行路径绘制
                    this.elements.push({
                      type: 'line',
                      color: '#000',
                      x: this.x_start,
                      y: this.y_start,
                      w: x,
                      h: y,
                      id: this.line_num
                    })
                    this.line_num++
                    this.Log.info(`elements length: ${this.elements.length}`)
                    this.x_start = x
                    this.y_start = y
                    this.dragging = false
                  }
                    break
                  default:
                    break
                }
              }
                break
              case 'drag': { //拖动模式
                switch (event.type) {
                  case TouchType.Down: { // 手指按下时
                    if (this.isMouseOnImage(x, y)) {
                      this.x_start = x;
                      this.y_start = y;
                      this.dragging = true;
                    }
                    else {
                      this.dragging = false
                    }
                  }
                    break

                  case TouchType.Move: { // 手指移动
                    if (this.dragging == true) {
                      this.image_pos.x = Number(this.image_pos.x) + (x - this.x_start)
                      this.image_pos.y = Number(this.image_pos.y) + (y - this.y_start)
                      this.y_start = y
                      this.x_start = x
                      let time = new Date()
                      let cost = time.getTime() - this.time_start.getTime()
                      //间隔一段时间刷新，避免卡顿
                      if (cost > 16) {
                        // 遍历元素数组，更新每个元素的坐标
                        for (var i = 0; i < this.elements.length; i++) {
                          // 获取当前的元素
                          var element = this.elements[i];

                          element.x += (x - this.x_start);
                          element.y += (y - this.y_start);
                        }
                        this.time_start = time;
                        this.drawElements();
                      }
                    }
                  }
                    break

                  case TouchType.Up: { // 手指抬起时
                    if (this.dragging == true) {
                      this.image_pos.x = Number(this.image_pos.x) + (x - this.x_start)
                      this.image_pos.y = Number(this.image_pos.y) + (y - this.y_start)
                      this.y_start = y
                      this.x_start = x
                      let time = new Date()
                      let cost = time.getTime() - this.time_start.getTime()
                      //间隔一段时间刷新，避免卡顿
                      if (cost > 16) {
                        // 遍历元素数组，更新每个元素的坐标
                        for (var i = 0; i < this.elements.length; i++) {
                          // 获取当前的元素
                          var element = this.elements[i];

                          element.x += (x - this.x_start)
                          element.y += (y - this.y_start)
                        }
                        this.time_start = time
                        this.dragging = false
                        this.drawElements();
                      }
                    }
                  }
                    break
                  default:
                    break
                }
              }
                break
              case 'rect': { //绘制矩形框
                if (this.isMouseOnImage(x, y) == false) {
                  this.Log.info(`${this.dragging}`)
                  if (this.dragging == true) {
                    this.dragging = false
                    this.elements.push({
                      type: 'rect',
                      x: this.x_start,
                      y: this.y_start,
                      w: this.rect_width,
                      h: this.rect_height,
                      color: '#000'
                    })
                    this.Log.info(`1`)
                  }
                  return
                }
                else {
                  switch (event.type) {
                    case TouchType.Down: { //获取矩形框初始位置
                      this.x_start = x;
                      this.y_start = y;
                      this.dragging = true
                    }
                      break

                    case TouchType.Move: {
                      let time = new Date()
                      let cost = time.getTime() - this.time_start.getTime()
                      //间隔一段时间刷新，避免卡顿
                      if (cost > 150 && (x - this.x_start > 0 && y - this.y_start > 0)) {
                        this.drawElements()
                        this.context.strokeRect(this.x_start, this.y_start, (x - this.x_start), (y - this.y_start))
                        this.rect_width = x - this.x_start
                        this.rect_height = y - this.y_start
                        this.time_start = time
                      }
                    }
                      break

                    case TouchType.Up: {
                      this.drawElements()
                      if (x - this.x_start > 0 && y - this.y_start > 0) {
                        this.context.strokeRect(this.x_start, this.y_start, (x - this.x_start), (y - this.y_start))
                        this.elements.push({
                          type: 'rect',
                          x: this.x_start,
                          y: this.y_start,
                          w: (x - this.x_start),
                          h: (y - this.y_start),
                          color: '#000'
                        })
                      }
                      this.dragging = false
                    }
                      break

                    default:
                      break
                  }
                }
              }
                break
            case 'text': {
              if (this.isMouseOnImage(x, y) == false) {
                this.Log.info(`${this.text_editor}`)
                if (this.text_editor == true) {
                  this.text_editor = false
                }
                return
              }
              switch (event.type){
                case TouchType.Down:{
                  if(this.text_editor == true) {
                    if (x > Number(this.text_area.position.x) + Number(this.text_area.width) || x < Number(this.text_area.position.x) || y > Number(this.text_area.position.y) + Number(this.text_area.height) || x < Number(this.text_area.position.y)) {
                      this.text_editor = false
                    }
                  }
                  else{
                    this.text_editor = true
                    this.x_start = x
                    this.y_start = y
                  }
                }break
              }
            }
              break
            }
          })
        TextInput({ placeholder: '请输入文字' , text: this.text_content})
          .visibility(this.text_editor == true ? Visibility.Visible : Visibility.None)
          .height(40)
          .onChange((value) => {
            this.text_content = value
          })
          .onSubmit(()=>{
            this.Log.info(`text submit`)
            this.context.font = '30px sans-serif'
            this.context.fillText(this.text_content,this.x_start,this.y_start)
            this.elements.push({type : 'text', x: this.x_start, y: this.y_start, content : this.text_content})
            this.text_editor = false
            this.text_content = ''
          })
          .onAreaChange((_s, value) => {
            this.text_area = value
          })
          .position({ x: this.x_start, y: this.y_start })
          .border({ width: 3, color: Color.Blue })
      }.border({ width: 3, color: Color.Blue })

      Divider().color(Color.White)
      Row() {
        Button() {
          Text('直线')
        }.onClick(() => {
          this.mode = (this.mode == 'line' ? 'drag' : 'line')
          this.Log.info(`mode is ${this.mode}`)
        }).height(50).width(100)

        Button() {
          Text('矩形')
        }.onClick(() => {
          this.mode = (this.mode == 'rect' ? 'drag' : 'rect')
          this.Log.info(`mode is ${this.mode}`)
        }).height(50).width(100)

        Button() {
          Text('文字')
        }.height(50).width(100).onClick(() => {
          this.mode = (this.mode == 'text' ? 'drag' : 'text')
          this.Log.info(`mode is ${this.mode}`)
        })

        Button() {
          Text('撤销')
        }.height(50).width(100).onClick(() => {
          this.Log.info(`elements length: ${this.elements.length}`)
          if (this.elements.length == 1) return;
          var s = this.elements.pop()
          if (s.type == 'line') this.line_num--;
          while (s.type == 'line' && s.id == this.line_num) {
            if (this.elements.length == 1) break;
            s = this.elements.pop()
          }
          this.Log.info(`elements length: ${this.elements.length}`)
          this.drawElements()
        })
      }.height('15%')
    }.backgroundColor(Color.Black)
  }
  //初始化加载图片
  onDraw() {
    if (!this.isInit) return;

    this.Log.info('onDraw', `canvas: width: ${this.context.width} height: ${this.context.height}`)
    this.Log.info('onDraw', `Image: width: ${this.image_size.x} height: ${this.image_size.y}`)

    //开始绘制图片
    //清空画布
    this.context.clearRect(0, 0, this.context.width, this.context.height)
    //保存状态
    this.context.save()
    //计算缩放比例
    this.scales = Math.min(this.context.width / Number(this.image_size.x), this.context.height / Number(this.image_size.y))
    //计算目标图片大小
    this.image_size.x = Number(this.image_size.x) * this.scales
    this.image_size.y = Number(this.image_size.y) * this.scales

    //使图片在视图中居中出现
    this.image_pos.x = (this.context.width - Number(this.image_size.x)) / 2
    this.image_pos.y = (this.context.height - Number(this.image_size.y)) / 2

    //绘制图片到画布中心
    if (!isNaN(this.image_size.x) && !isNaN(this.image_size.y)) {
      this.elements.push({
        type: "image",
        x: this.image_pos.x,
        y: this.image_pos.y,
        w: this.image_size.x,
        h: this.image_size.y,
        scale: this.scales,
        angle: this.angle,
        img: this.pxImage
      })
      this.drawElements()
    }
  }

  //绘制各种元素
  drawElements() {
    this.context.clearRect(0, 0, this.context.width, this.context.height)
    for (var i = 0; i < this.elements.length; i++) {
      var element = this.elements[i]
      if (element) {
        // this.Log.info('drawElements', `element type ${element.type} x ${element.x} y ${element.y} w ${element.w} h ${element.h} long${this.elements.length}`)
        switch (element.type) {
          case 'image': {
            this.context.drawImage(element.img, element.x, element.y, element.w, element.h)
          }
            break
          case 'rect': {
            this.context.strokeStyle = element.color;
            this.context.lineWidth = 2;
            this.context.strokeRect(element.x, element.y, element.w, element.h);
          }
            break
          case 'line': {
            this.context.strokeStyle = element.color;
            this.context.lineWidth = 2;
            this.context.beginPath();
            this.context.moveTo(element.x, element.y);
            this.context.lineTo(element.w, element.h);
            this.context.closePath();
            this.context.stroke();
          }
            break
          case 'text':{
            this.context.fillText(element.context, element.x, element.y)
          }
        }
      }
      else {
        this.Log.error('drawElements', `there ${i} element is undefined`)
        break
      }


    }
  }
  //检测事件是否发生在图片之上
  isMouseOnImage(mouseX, mouseY) {
    this.Log.info(`Touch position : ${mouseX} ${mouseY}`)
    this.Log.info(`Touch image Pos ${this.image_pos.x} ${this.image_pos.y}`)
    this.Log.info(`Touch image Size ${this.image_size.x} ${this.image_size.y}`)
    // 计算图片的四个顶点的坐标
    var x1 = Number(this.image_pos.x) + Number(this.image_size.x) * (Math.cos(this.angle * Math.PI / 180) - Math.sin(this.angle * Math.PI / 180));
    var y1 = Number(this.image_pos.y) + Number(this.image_size.y) * (Math.cos(this.angle * Math.PI / 180) + Math.sin(this.angle * Math.PI / 180));
    this.Log.info(`1 ${x1} ${y1}`)
    // 判断鼠标是否在图片的四边形区域内
    var s = (this.image_pos.x < mouseX && mouseX < x1) && (this.image_pos.y < mouseY && mouseY < y1)
    this.Log.info(`isonPhoto: ${s}`)
    return s
  }
}