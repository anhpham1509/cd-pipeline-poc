import React from "react"
import enzyme from "enzyme"

import {App} from "./App"

describe("<App>", () => {
  it("should render Hello World!", () => {
    const app = enzyme.render(<App show={false}/>)
    expect(app).toMatchSnapshot()
  })
})
