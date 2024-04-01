import { Button, Space } from "antd";
import React, { useEffect, useMemo, useRef } from "react";
import { Statistic, Divider } from "antd";
import { HeartOutlined, HeartTwoTone } from "@ant-design/icons";
import { debounce } from "lodash";
import axios, { AxiosResponse } from "axios";

function MyApp() {

  const [clicked, setClicked] = React.useState<number>(0);
  useEffect(() => {
    axios
      .get("http://localhost:3000/count")
      .then((res: AxiosResponse) => {
        setClicked(res.data)
      })
  })
  function incrementCount() {
    setClicked(clicked + 1);
  }
  function handleClick() {
    incrementCount();
    debouncedRequest()
  }
  const useDebounce = (callback: any) => {
    const ref = useRef<() => void>();

    useEffect(() => {
        ref.current = callback;
    }, [callback]);

    const debouncedCallback = useMemo(() => {
        const func = () => {
            ref.current?.();
        };

        return debounce(func, 1000);
    }, []);
  
    return debouncedCallback;
  };

  const debouncedRequest = useDebounce(() => {
    console.log(clicked);
  });
  return (
    <div className="App">
      <Space direction="vertical">
        <Statistic
          valueStyle={{ color: "#520000" }}
          title="Love Counter"
          value={clicked}
          prefix={<HeartOutlined />}
        />
        <Button type="primary" onClick={handleClick}>
          For Cat
        </Button>
        <Divider />
        <div>
          {Array.from({ length: clicked }, (_, i) => {
            return <HeartTwoTone twoToneColor="#520000" />;
          })}
        </div>
      </Space>
    </div>
  );
}
export default MyApp;
