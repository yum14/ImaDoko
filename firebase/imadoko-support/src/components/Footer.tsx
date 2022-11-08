import React from 'react';
import { css } from '@emotion/css';
import { COLORS } from '../common/theme';

const styles = {
    container: css`
        background-color: ${COLORS.MAIN};
    `,
    text: css`
        display: block;
        color: #fff;
        font-size: 1.2rem;
        text-align: center;
        font-weight: bold;
    `,
}

const Footer = () => {
    return (
        <footer className={styles.container}>
            <small className={styles.text}>&copy;2022 yum All Rights Reserved.</small>
        </footer>
    )
};

export default Footer;