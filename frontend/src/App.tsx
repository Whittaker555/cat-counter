import { ConfigProvider} from 'antd';
import React from 'react';
import MyButton from './components/mybutton';

const App: React.FC = () => (
  <ConfigProvider theme={{ token: { colorPrimary: 'black' } }}>
    <div className="App">
    <MyButton title='click'/>
  </div>
  </ConfigProvider>
  
);

export default App;