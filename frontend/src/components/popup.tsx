import { HeartOutlined } from '@ant-design/icons';

interface PopupProps {
    key: number;
    message: string;
}

function Popup(props: PopupProps) {
    return (
      <>
        <p>{props.message}</p>
        <HeartOutlined />
      </>

    );
  } export default Popup;