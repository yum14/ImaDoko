import React from 'react';
import { Introduction, Contact, Policy } from './pages';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path={`/home`} element={<Introduction />} />
        <Route path={`/contact`} element={<Contact />} />
        <Route path={`/policy`} element={<Policy />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
