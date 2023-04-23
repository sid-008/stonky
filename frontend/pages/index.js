import Image from 'next/image'
import { Inter } from 'next/font/google'
import { useState, useEffect } from 'react';
import fetchData from '../utils/getData';

const inter = Inter({ subsets: ['latin'] })

export default function Home() {
const [data, setData] = useState(null);

  useEffect(() => {
    const fetchDataAsync = async () => {
      const url = 'http://127.0.0.1:5000/get';
      const result = await fetchData(url);
      setData(result);
    };

    fetchDataAsync();
  }, []);

  return (
    <main className={`flex min-h-screen flex-col items-center justify-between p-24 ${inter.className}`}>
      <h1> Stonky </h1>
    <div>
          {data && (
            <p>{JSON.stringify(data, null, 2)}</p>
          )}
    </div>
      

    </main>
  )
}
