import { ConfigProvider} from 'antd';
import React from 'react';
import MyApp from './MyApp';

const App: React.FC = () => (
  <ConfigProvider theme={{ token: { colorPrimary: 'black' } }}>
   <MyApp/>
  </ConfigProvider>
  
);

export default App;