import React from 'react';
import { css, cx } from '@emotion/css';
import { Header, Footer } from '../components';

const styles = { 
    container: css`
        display: flex;
        flex-flow: column;
        height: 100%;
        margin: 0 auto;
    `,
    main: css`
        flex: 1;
    `,
}

type Props = {
    className?: string;
    children: React.ReactNode;
}

const ContentTemplate = (props: Props) => {
    const { className, children } = props;
    const mainStyle = cx(styles.main, className);

    return (
        <div className={styles.container}>
            <Header />

            <main className={mainStyle}>
                {children}
            </main>

            <Footer />
        </div>
    )
}

export default ContentTemplate;