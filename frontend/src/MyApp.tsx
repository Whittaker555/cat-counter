import { Button, Space, Layout } from 'antd';
import React from "react";
import Popup from "./components/popup";
import { Statistic, Divider } from 'antd';
import { HeartOutlined, HeartTwoTone } from '@ant-design/icons';

function MyApp() {

    const [clicked, setClicked] = React.useState<number>(0);

    function handleClick() {
        setClicked(clicked + 1);
    }

    return (
            <div className="App">
                <Space direction='vertical'>
                <Statistic valueStyle={{ color: '#520000' }} title="Love Counter" value={clicked} prefix={<HeartOutlined />} />
                <Button type="primary" onClick={handleClick}>For Cat</Button>
                <Divider />
                <div>
                {
                    Array.from({ length: clicked }, (_, i) => {
                        return <HeartTwoTone twoToneColor="#520000" />
                    })
                }
                </div>
                </Space>
        </div>
    );
    } export default MyApp;
