import mill._,scalalib._,scalafmt._,mill.bsp._
import mill.scalalib.TestModule.ScalaTest

object foo extends RootModule with ScalaModule with ScalafmtModule{ m =>
  override def scalaVersion = "2.13.12"
  override def scalacOptions = Seq(
    "-language:reflectiveCalls",
    "-deprecation",
    "-feature",
    "-Xcheckinit",
  )
  override def ivyDeps = Agg(
    ivy"org.chipsalliance::chisel:6.5.0",
  )
  
  override def scalacPluginIvyDeps = Agg(
    ivy"org.chipsalliance:::chisel-plugin:6.5.0",
  )

  object test extends ScalaTests with ScalaTest with ScalafmtModule{
    override def ivyDeps = m.ivyDeps() ++Agg(
      ivy"edu.berkeley.cs::chiseltest:6.0.0"
    )
  }
}
