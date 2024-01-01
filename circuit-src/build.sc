import mill._,scalalib._,scalafmt._,mill.bsp._
import mill.scalalib.TestModule.ScalaTest

object foo extends RootModule with ScalaModule with ScalafmtModule{ m=>
  def scalaVersion = "2.13.10"
  override def scalacOptions = Seq(
    "-language:reflectiveCalls",
    "-deprecation",
    "-feature",
    "-Xcheckinit",
  )
  def ivyDeps = Agg(
    ivy"org.chipsalliance::chisel:5.1.0",
  )
  
  override def scalacPluginIvyDeps = Agg(
    ivy"org.chipsalliance:::chisel-plugin:5.1.0",
  )

  object test extends ScalaTests with ScalaTest with ScalafmtModule{
    override def ivyDeps = m.ivyDeps() ++Agg(
      ivy"edu.berkeley.cs::chiseltest:5.0.2"
    )
  }
}