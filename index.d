import std.stdio;

void main() {
  auto et = new Eventable;
  et.on!"hello"((e) => writeln(e));
  //et.on("hello", (e) => writeln(e));
  et.callSomeEvents;
}

mixin template Events(T, string[] evs) {
  private void delegate(T)[string] handlers;
  import std.algorithm;
  public bool on(string ev, void delegate(T) handler) {
    //writeln("Calling function");
    if(evs.canFind(ev)) {
      handlers[ev] = handler;
      return true;
    }
    return false;
  }
  public bool on(string ev)(void delegate(T) handler) if(evs.canFind(ev)) {
    //writeln("Calling template");
    handlers[ev] = handler;
    return true;
  }
  public bool on(string ev, void delegate(T) handler)() if(evs.canFind(ev)) {
    //writeln("Calling full template");
    handler[ev] = handler;
    return true;
  }
  private bool emit(string ev, T data) {
    if(evs.canFind(ev) && handlers[ev]) {
      handlers[ev](data);
      return true;
    }
    return false;
  }
  private bool emit(string ev)(T data) if(evs.canFind(ev)) {
    if(handlers[ev]) {
      handlers[ev](data);
      return true;
    }
    return false;
  }
  private bool emit(string ev, T data)() if(evs.canFind(ev)) {
    if(handlers[ev]) {
      handlers[ev](data);
      return true;
    }
    return false;
  }
}

class Eventable {
  mixin Events!(string, ["hello"]);
  void callSomeEvents() {
    emit("hello", "world");
  }
}
