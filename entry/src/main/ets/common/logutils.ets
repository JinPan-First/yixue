import hilog from '@ohos.hilog'
/*
此类为日志封装类，截取自鸿蒙官方文档，比自带原生的hilog更加方便
*/
export default class Logger {
  private domain: number
  private prefix: string
  private format: string = '%{public}s, %{public}s'

  constructor(prefix: string) {
    this.prefix = prefix
    this.domain = 0xFF00
  }

  debug(...args: string[]) {
    hilog.debug(this.domain, this.prefix, this.format, args)
  }

  info(...args: string[]) {
    hilog.info(this.domain, this.prefix, this.format, args)
  }

  warn(...args: string[]) {
    hilog.warn(this.domain, this.prefix, this.format, args)
  }

  error(...args: string[]) {
    hilog.error(this.domain, this.prefix, this.format, args)
  }
}