import { ConfigProvider} from 'antd';
import React from 'react';
import MyButton from './components/mybutton';
import MyApp from './MyApp';

const App: React.FC = () => (
  <ConfigProvider theme={{ token: { colorPrimary: 'black' } }}>
   <MyApp/>
  </ConfigProvider>
  
);

export default App;