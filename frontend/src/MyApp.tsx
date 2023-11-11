import { Button } from 'antd';
import React, { useState } from "react";
import Popup from "./components/popup";

function MyApp() {

    const [clicked, setClicked] = React.useState<number>(0); // default is 'middle'

        return (
                <div className="App">
                <Button type="primary" onClick={() => setClicked(clicked + 1)}>ForCat</Button>
                {
                        Array.from({ length: clicked }, (_, i) => {
                            if (i == 5) {
                                return <h1>I LOVE YOU!</h1>
                            }
                            return <Popup key={i} />
                        })
                }
            </div>
        );
    } export default MyApp;
