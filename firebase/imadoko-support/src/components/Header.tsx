import React from 'react';
import { css } from '@emotion/css';
import { logo } from '../images';

import {  } from '../images';

import { COLORS } from '../common/theme';

const styles = {
    container: css`
        display: flex;
        background-color: ${COLORS.MAIN};
        justify-content: center;
        align-items: center;
        padding: 20px 0;
    `,
    innerContainer: css`
        display: flex;
        width: 72%;
        flex-flow: column;
    `,
    logoContainer: css`
        display: flex;
        justify-content: center;
        align-items: center;
    `,
    logo: css`
        width: 100px;
        margin: 0;
    `,
    appNameContainer: css`
        margin-left: 8px;
        text-align: center;
    `,
    appName: css`
        color: #fff;
        font-weight: bold;
        font-size: 3.4rem;
        letter-spacing: 0.16rem; 
        margin: 6px 0 0 0;
    `,
    appDesc: css`
        color: #FFF;
        font-weight: bold;
        letter-spacing: 0.12rem; 
        margin: 8px 0 0 0;
    `,
}

const Header = () => {
    return (
        <header className={styles.container}>
            <div className={styles.innerContainer}>
                <div className={styles.logoContainer}>
                    <img className={styles.logo} src={logo} alt="logo" />

                    <div className={styles.appNameContainer}>
                        <p className={styles.appName}>Imadoko</p>
                        <p className={styles.appDesc}>-位置情報共有アプリ-</p>
                    </div>
                </div>
            </div>
        </header>
    )
};

export default Header;