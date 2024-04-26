import { ConfigProvider, Space, Layout} from 'antd';
import React from 'react';
import CatCounter from './cat-counter';

const { Header, Footer, Content } = Layout;
const headerStyle: React.CSSProperties = {
  textAlign: 'center',
  color: '#fff',
  height: 64,
  paddingInline: 50,
  lineHeight: '64px',
  backgroundColor: 'black',
};

const contentStyle: React.CSSProperties = {
  textAlign: 'center',
  minHeight: 120,
  lineHeight: '1px',
  color: '#fff',
  backgroundColor: 'black',
};

const footerStyle: React.CSSProperties = {
  textAlign: 'center',
  color: '#fff',
  backgroundColor: 'black',
};

const App: React.FC = () => (
  <ConfigProvider theme={{ token: { colorPrimary: '#520000' } }}>
    <Space direction="vertical" style={{ width: '100%' }} size={[0, 48]}>
      <Layout>
        <Content style={contentStyle}>
          <CatCounter/>
          </Content>
        <Footer style={footerStyle}>A special website for a special lady</Footer>
      </Layout>
    </Space>
  </ConfigProvider>
  
);

export default App;