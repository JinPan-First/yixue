// xxx.ets
import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import http from '@ohos.net.http'
import Logger from '../common/logutils'
import variable from '../common/variable'


@Entry
@Component
struct Index {
  @State changeValue: string = ''
  controller: SearchController = new SearchController()
  aboutToAppear() {
    let contexts = getContext(this) as common.UIAbilityContext
    let atManager = abilityAccessCtrl.createAtManager()
    try {
      atManager.requestPermissionsFromUser(contexts, ['ohos.permission.READ_MEDIA', 'ohos.permission.WRITE_MEDIA', 'ohos.permission.INTERNET'])
    } catch (err) {
    }
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
        variable.lessons = JSON.parse(data.result.toString())
        // Log.info(`Result: ${this.lesson_table[3][1][0].name}`)

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
        Image($r('app.media.label')).objectFit(ImageFit.Contain).height(200).width(200)
      }.margin({ top: 50 })

      Column() {
        Search({ value: this.changeValue, placeholder: 'Hi,...', controller: this.controller })
          .width('100%')
          .height(40)
          .backgroundColor('#F5F5F5')
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14, weight: 400 })
          .textFont({ size: 14, weight: 400 })
          .onChange((value: string) => {
            this.changeValue = value
          })
        List() {

          ListItem() {
            Text('1')
          }

          ListItem() {
            Text('1')
          }

          ListItem() {
            Text('1')
          }

          ListItem() {
            Text('1')
          }

        }
        .borderRadius(20)
        .backgroundColor(Color.White)
        .width('80%')
        .height(60)
        .visibility(this.changeValue.length == 0 ? Visibility.None : Visibility.Visible)

        Button('课表').onClick(() => {

          router.pushUrl({
            url: 'pages/Lesson'
          }, router.RouterMode.Single)
        })
        Button('笔记').onClick(() => {
          router.pushUrl({
            url: 'pages/Note'
          }, router.RouterMode.Single)
        })
      }
      .backgroundColor(this.changeValue.length == 0 ? '#e4f7fd' : Color.White)
      .borderRadius(35)
      .width('80%')
      .margin({ top: 30 })
    }.width('100%').height('100%').backgroundColor('#e4f7fd')
  }
}