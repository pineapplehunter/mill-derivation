import circt.stage.ChiselStage
import chisel3._
import chisel3.util._

class TestModule extends Module {
  val in = IO(Input(UInt(8.W)))
  val out = IO(Output(UInt(4.W)))
  out := in(3, 0) ^ in(7, 4)
}

object Main extends App {
  println("Hello World!")
  ChiselStage.emitSystemVerilogFile(new TestModule)
}
