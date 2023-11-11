import { Button } from 'antd';

interface MyButtonProps {
    title: string;
  }
  

function MyButton({ title }: MyButtonProps) {
    return (
      <Button type="primary">Primary Button</Button>
    );
  } export default MyButton;