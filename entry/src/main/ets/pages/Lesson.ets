import LessonTable from '../views/LessonTable'
import http from '@ohos.net.http'
import Logger from '../common/logutils'

@Entry
@Component
struct Lesson {
  //定义全局时间
  private time = new Date()
  @State date_show: string = this.time.getFullYear()
    .toString() + ' 年 ' + (this.time.getMonth() + 1).toString() + ' 月 ' + this.time.getDate().toString() + ' 日'
  //当前选择周
  @State currentWeek: number = 3
  @State lesson_table: object = []
  @State TabIndex: number = 1
  //实际周
  private actualWeek: number = 3
  private controller: TabsController = new TabsController()

  aboutToAppear() {

    var Log = new Logger('request')
    // 每一个httpRequest对应一个HTTP请求任务，不可复用
    let httpRequest = http.createHttp();
    // 用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息
    // 从API 8开始，使用on('headersReceive', Callback)替代on('headerReceive', AsyncCallback)。 8+
    httpRequest.on('headersReceive', (header) => {
      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      "http://192.168.28.128:8080/submit",
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json'
        },
        // 当使用POST请求时此字段用于传递内容
        extraData: {
          "data": "data to send",
        },
        expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
        usingCache: true, // 可选，默认为true
        priority: 1, // 可选，默认为1
        connectTimeout: 60000, // 可选，默认为60000ms
        readTimeout: 60000, // 可选，默认为60000ms
        usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
      }, (err, data) => {
      if (!err) {
        Log.info(typeof JSON.parse(data.result.toString()))
        this.lesson_table = JSON.parse(data.result.toString())
        Log.info(`Result: ${this.lesson_table[3][1][0].name}`)

        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      } else {
        Log.info('error:' + JSON.stringify(err));
        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，调用destroy方法主动销毁。
        httpRequest.destroy();
      }
    }
    );
  }

  build() {
    Column() {
      Row() {
        Column() {
          Text(this.date_show)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text(this.currentWeek.toString())
          Text(this.actualWeek.toString())
        }
        .width('100%').height('10%')
      }

      Divider()
      Tabs({ barPosition: BarPosition.Start, index: this.TabIndex, controller: this.controller }) {
        TabContent() {
          Column() {
            LessonTable({ week: $currentWeek, lesson_table:$lesson_table})
          }.width('100%').height('100%')
        }

        TabContent() {
          Column() {
            LessonTable({ week: $currentWeek, lesson_table:$lesson_table})
          }
          .width('100%').height('100%')
        }

        TabContent() {
          Column() {
            LessonTable({ week: $currentWeek, lesson_table:$lesson_table})
          }.width('100%').height('100%')
        }
      }
      .vertical(false)
      .barWidth(0)
      .barHeight(0)
      .animationDuration(400)
      .onChange((index: number) => {
        this.TabIndex = index
        this.currentWeek = index == 0 ? this.currentWeek - 1 : index == 2 ? this.currentWeek + 1 : this.currentWeek;
        this.TabIndex = 1
      })
      .width('100%')
      .height('100%')
    }.width('100%').backgroundColor('#e4f7fd').height('100%')
  }

}