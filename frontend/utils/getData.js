import axios from 'axios';

const fetchData = async (url) => {
  try {
    const response = await axios.get("http://127.0.0.1:5000/get");
    return response.data;
  } catch (error) {
    console.error(error);
    return null;
  }
};

export default fetchData;
