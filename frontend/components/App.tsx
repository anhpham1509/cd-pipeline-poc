import React from "react"
import {hot} from "react-hot-loader"
import "./App.scss"

interface Props {
  show: boolean
}

interface State {
}

export class App extends React.Component<Props, State> {
  public render() {
    const {show} = this.props;
    return (
      <div className="app">
        {show && <h1>Hello World!</h1>}
      </div>
    )
  }
}

export default hot(module)(App)
